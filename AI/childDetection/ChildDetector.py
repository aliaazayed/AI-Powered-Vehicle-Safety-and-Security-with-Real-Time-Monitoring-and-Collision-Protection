import cv2
import numpy as np
import tensorflow as tf
import argparse
import os


def detect_faces(image, face_net, confidence_threshold=0.5):

    # Get image dimensions
    (h, w) = image.shape[:2]

    blob = cv2.dnn.blobFromImage(cv2.resize(image, (300, 300)), 1.0,
                                 (300, 300), (104.0, 177.0, 123.0))

    # Pass the blob through the network and get detections
    face_net.setInput(blob)
    detections = face_net.forward()

    # Lists to store face locations and confidences
    faces = []
    face_confidences = []

    # Loop over the detections
    for i in range(0, detections.shape[2]):
        # Extract the confidence of the detection
        confidence = detections[0, 0, i, 2]

        # Filter out weak detections
        if confidence > confidence_threshold:
            # Compute the (x, y)-coordinates of the bounding box
            box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
            (startX, startY, endX, endY) = box.astype("int")

            # Ensure the bounding boxes are within the dimensions of the frame
            startX = max(0, startX)
            startY = max(0, startY)
            endX = min(w, endX)
            endY = min(h, endY)

            # Calculate width and height of the face
            width = endX - startX
            height = endY - startY

            # Add the face and confidence to the lists
            faces.append((startX, startY, width, height))
            face_confidences.append(float(confidence))

    return faces, face_confidences


def classify_age(face_img, age_model, img_size=105):
    # Convert to grayscale
    gray_img = cv2.cvtColor(face_img, cv2.COLOR_BGR2GRAY)

    # Resize to required dimensions
    resized_img = cv2.resize(gray_img, (img_size, img_size))

    # Normalize pixel values to [0, 1]
    normalized_img = resized_img / 255.0

    # Add batch and channel dimensions
    input_img = np.expand_dims(normalized_img, axis=0)  # Add batch dimension
    input_img = np.expand_dims(input_img, axis=-1)  # Add channel dimension

    # Get prediction
    prediction = age_model.predict(input_img, verbose=0)[0]

    # Get class with highest probability
    # Index 0: Child, Index 1: Adult
    predicted_class = np.argmax(prediction)
    confidence = prediction[predicted_class]

    # Return True for adult, False for child
    is_adult = (predicted_class == 1)

    return is_adult, float(confidence)


def process_video(video_source, face_net, age_model, output_path=None, img_size=105):

    # Initialize video capture
    cap = cv2.VideoCapture(video_source)

    # Check if video opened successfully
    if not cap.isOpened():
        print(f"Error: Could not open video source {video_source}")
        return

    # Get video properties
    frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fps = cap.get(cv2.CAP_PROP_FPS)

    # Initialize video writer if output path is provided
    out = None
    if output_path:
        fourcc = cv2.VideoWriter_fourcc(*'XVID')
        out = cv2.VideoWriter(output_path, fourcc, fps, (frame_width, frame_height))

    frame_count = 0

    while True:
        # Read a frame
        ret, frame = cap.read()
        if not ret:
            break

        frame_count += 1
        # Clone the frame for display
        display_frame = frame.copy()

        # Detect faces in the frame
        faces, confidences = detect_faces(frame, face_net)

        # Process each detected face
        for ((x, y, w, h), conf) in zip(faces, confidences):
            # Extract the face ROI (Region of Interest)
            face_roi = frame[y:y + h, x:x + w]

            # Skip if face ROI is empty (can happen at image boundaries)
            if face_roi.size == 0:
                continue

            # Classify the face as child or adult
            is_adult, age_conf = classify_age(face_roi, age_model, img_size)

            # Set label and color based on classification
            if is_adult:
                label = "Adult"
                color = (0, 255, 0)  # Green for adults
            else:
                label = "Child"
                color = (0, 0, 255)  # Red for children

            # Draw the bounding box
            cv2.rectangle(display_frame, (x, y), (x + w, y + h), color, 2)

            # Display the classification and confidence
            text = f"{label}: {age_conf:.2f}"
            cv2.putText(display_frame, text, (x, y - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

            # Add face detection confidence
            face_text = f"Face: {conf:.2f}"
            cv2.putText(display_frame, face_text, (x, y + h + 15),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

        # Display frame count
        cv2.putText(display_frame, f"Frame: {frame_count}", (10, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)

        # Write the frame to the output video if specified
        if out:
            out.write(display_frame)

        # Display the frame
        cv2.imshow("Face Detection & Age Classification", display_frame)

        # Break the loop on 'q' key press
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release resources
    cap.release()
    if out:
        out.release()
    cv2.destroyAllWindows()


def process_image(image_path, face_net, age_model, output_path=None, img_size=105):

    # Read the image
    image = cv2.imread(image_path)

    if image is None:
        print(f"Error: Could not read image at {image_path}")
        return

    # Detect faces in the image
    faces, confidences = detect_faces(image, face_net)

    # Process each detected face
    for ((x, y, w, h), conf) in zip(faces, confidences):
        # Extract the face ROI (Region of Interest)
        face_roi = image[y:y + h, x:x + w]

        # Skip if face ROI is empty 
        if face_roi.size == 0:
            continue

        # Classify the face as child or adult
        is_adult, age_conf = classify_age(face_roi, age_model, img_size)

        # Set label and color based on classification
        if is_adult:
            label = "Adult"
            color = (0, 255, 0)  # Green for adults
        else:
            label = "Child"
            color = (0, 0, 255)  # Red for children

        # Draw the bounding box
        cv2.rectangle(image, (x, y), (x + w, y + h), color, 2)

        # Display the classification and confidence
        text = f"{label}: {age_conf:.2f}"
        cv2.putText(image, text, (x, y - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

        # Add face detection confidence
        face_text = f"Face: {conf:.2f}"
        cv2.putText(image, face_text, (x, y + h + 15),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

    # Save the output image if specified
    if output_path:
        cv2.imwrite(output_path, image)
        print(f"Output saved to {output_path}")

    # Display the image
    cv2.imshow("Face Detection & Age Classification", image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


def main():
    
    parser = argparse.ArgumentParser(description='Face detection and age classification')
    parser.add_argument('--face-prototxt', required=True, help='Path to face detection prototxt')
    parser.add_argument('--face-model', required=True, help='Path to face detection model')
    parser.add_argument('--age-model', required=True, help='Path to age classification model (TensorFlow .h5 file)')
    parser.add_argument('--input', required=True,
                        help='Path to input image or video file, or camera index (0 for webcam)')
    parser.add_argument('--output', help='Path to output file (optional)')
    parser.add_argument('--confidence', type=float, default=0.5, help='Minimum probability to filter weak detections')
    parser.add_argument('--img-size', type=int, default=105, help='Image size for age classification model')

    args = parser.parse_args()

    # Load the face detection model
    print("Loading face detection model...")
    face_net = cv2.dnn.readNet(args.face_model, args.face_prototxt)

    # Load the age classification model
    print("Loading age classification model...")
    age_model = tf.keras.models.load_model(args.age_model)

    # Check if input is an image or video
    if args.input.endswith(('.jpg', '.jpeg', '.png', '.bmp')):
        # Process image
        print(f"Processing image: {args.input}")
        process_image(args.input, face_net, age_model, args.output, args.img_size)
    else:
        # Process video (file or webcam)
        try:
           
            video_source = int(args.input)
            print(f"Processing webcam feed from camera index {video_source}")
        except ValueError:
            video_source = args.input
            print(f"Processing video file: {video_source}")

        process_video(video_source, face_net, age_model, args.output, args.img_size)

    print("Processing complete.")


if __name__ == "__main__":
    main()
# integ.py --face-prototxt deploy.prototxt.txt  --face-model res10_300x300_ssd_iter_140000.caffemodel --age-model best_model_fold_1.h5 --input VID-20250503-WA0084.mp4  --output lola.mp4
