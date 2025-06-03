const { User } = require('../data/mongodb');

async function signup(req, res) {
    const { username, email, password } = req.body;

    try {
        const existing = await User.findOne({ email });
        if (existing) {
            return res.status(400).json({ message: 'duplicate email' });
        }

        const newUser = new User({ username, email, password });
        await newUser.save();

        res.status(201).json({ message: 'Registered' });
    } catch (err) {
        res.status(500).json({ message: 'Signup failed' });
    }
}

async function login(req, res) {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user || user.password !== password) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        res.status(200).json({ message: 'Login', username: user.username });
    } catch (err) {
        res.status(500).json({ message: 'Login failed' });
    }
}

async function verifyOtp(req, res) {
    //
}

module.exports = {
    signup,
    login,
    verifyOtp
};
