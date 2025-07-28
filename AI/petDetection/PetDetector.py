from ultralytics import YOLO
import  os


DATA_YAML_PATH = "cat_dog.yaml"

def train_model():

    model = YOLO("yolov8n.pt")

 
    results = model.train(
        data=DATA_YAML_PATH,
        epochs=11,
        patience=10,
        batch=16,
        imgsz=640,
        save=True
    )

    return model

ROOT_DIR = "datasets/yolo_data"
IMAGES_DIR = os.path.join(ROOT_DIR, "images")
LABELS_DIR = os.path.join(ROOT_DIR, "labels")


def predict_and_evaluate(model):
    # Validate the model
    metrics = model.val()
    print(f"Validation metrics: {metrics}")

    # Run inference on validation images
    test_img_path = os.path.join(IMAGES_DIR, "val")
    results = model.predict(source=test_img_path, save=True, conf=0.25)

    for result in results:
        detected_classes = [model.names[int(box.cls)] for box in result.boxes]
        # Check if any pet (cat or dog) was detected
        if any(cls in ['cat', 'dog'] for cls in detected_classes):
            print(f"Image {result.path} → Pet detected.")
        else:
            print(f"Image {result.path} → No pet detected.")

    print("Prediction completed. Results saved to runs/detect/predict")


def main():
    print("Starting YOLOv8 training for cat and dog detection...")

    # Check if dataset exists with expected structure
    if not os.path.exists(IMAGES_DIR) or not os.path.exists(LABELS_DIR):
        print(f"Error: Required directories not found. Please ensure {IMAGES_DIR} and {LABELS_DIR} exist.")
        return

    train_img_dir = os.path.join(IMAGES_DIR, "train")
    val_img_dir = os.path.join(IMAGES_DIR, "val")
    train_label_dir = os.path.join(LABELS_DIR, "train")
    val_label_dir = os.path.join(LABELS_DIR, "val")

    for directory in [train_img_dir, val_img_dir, train_label_dir, val_label_dir]:
        if not os.path.exists(directory):
            print(f"Error: {directory} not found. Please check your dataset structure.")
            return

    # Train the model
    model = train_model()

    # Evaluate and run predictions
    predict_and_evaluate(model)

    print("Training and evaluation completed!")


if __name__ == "__main__":
    main()