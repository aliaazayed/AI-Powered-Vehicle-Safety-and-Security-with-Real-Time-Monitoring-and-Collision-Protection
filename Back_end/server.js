const express = require('express');
const bodyParser = require('body-parser');
const connectDB = require('./config/db'); 
const path = require('path');

console.log("📌 server.js file loaded...");
console.log("🔁 Redeploy triggered by Marium on 26/6");
console.log("🌐 Checking DB connection after allowing Azure IP");

// ✅ Connect to DB
connectDB();

const app = express();
const PORT = process.env.PORT || 3000;

// ✅ Middleware to parse JSON bodies
app.use(bodyParser.json());

// ✅ Serve static files from 'uploads' folder (images)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// ✅ Import routes
const loginRoutes = require('./routes/login');
const registerRoutes = require('./routes/register');
const userRoutes = require('./routes/userRoutes');
const RegistrationRoute = require('./routes/Registration'); 
const invitationRoute = require('./routes/invitationroute'); 
const deviceRoutes = require('./routes/deviceroutes');
const carRoutesCompany = require('./routes/carroutescompany');
const permanentRoute = require('./routes/permanentroute');
const onceRoute = require('./routes/onceroute'); 
const guestRoute = require('./routes/guestroute');
const notificationRoute = require('./routes/notificationroute');
const backupRoute = require('./routes/backupRoute');

app.use(express.static(path.join(__dirname, 'public')));
// ✅ Use routes
app.use('/register', registerRoutes);
app.use('/login', loginRoutes);
app.use('/users', userRoutes);
app.use('/Registration', RegistrationRoute); 
app.use('/invitation', invitationRoute); 
app.use('/devices', deviceRoutes);
app.use('/company-cars', carRoutesCompany);
app.use('/permanent', permanentRoute);
app.use('/once', onceRoute); 
app.use('/guest', guestRoute);
app.use('/notifications', notificationRoute);
app.use('/api', backupRoute);



// ✅ Start server
app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
});
