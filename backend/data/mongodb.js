const mongoose = require('mongoose');

mongoose.connect('mongodb://127.0.0.1:27017/chatApp', {
    useNewUrlParser: true,
    useUnifiedTopology: true
})

const userSchema = new mongoose.Schema({
    username: String,
    email: { type: String, unique: true },
    password: String
});

const User = mongoose.model('User', userSchema);

module.exports = { User };
