const express = require('express');
const cors = require('cors');

const app = express();

// Enable CORS for all routes
app.use(cors());

// ... other route and server setup

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
