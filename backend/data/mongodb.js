const mongoose = require('mongoose');
require('dotenv').config();

password = process.env.DB_PASSWORD

mongoose.connect(`mongodb+srv://gokulpjayan2004:${password}@cluster0.infebp8.mongodb.net/chatApp?retryWrites=true&w=majority&appName=Cluster0`, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log("Connected to MongoDB Atlas");
}).catch((err) => {
    console.error("Connection error:", err);
});

const userSchema = new mongoose.Schema({
    username: String,
    email: { type: String, unique: true },
    password: String
});

const User = mongoose.model('User', userSchema);

module.exports = { User };

