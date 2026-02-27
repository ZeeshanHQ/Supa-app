// ============================================
// Supabase Pulse — API Server Entry Point
// ============================================
import express from 'express';
import cors from 'cors';
import { handleAuthExchange } from './server.js';
import { validateConfig } from './config.js';

// 1. Initialise & Validate
try {
    validateConfig();
} catch (error) {
    console.error('❌ Config Validation Failed:', error.message);
    process.exit(1);
}

const app = express();
const PORT = process.env.PORT || 3000;

// 2. Middlewares
app.use(cors()); // Allow Flutter Web (CORS)
app.use(express.json()); // Parse JSON bodies

// 3. Routes
// Flutter calls this after receiving the code from Supabase
app.post('/api/auth/exchange', handleAuthExchange);

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok', service: 'Supabase Pulse Backend' }));

// 4. Start Server
app.listen(PORT, () => {
    console.log(`\n🚀 SUPABASE PULSE BACKEND IS LIVE`);
    console.log(`------------------------------------`);
    console.log(`Local URL  : http://localhost:${PORT}`);
    console.log(`Health     : http://localhost:${PORT}/health`);
    console.log(`Endpoint   : http://localhost:${PORT}/api/auth/exchange`);
    console.log(`------------------------------------\n`);
    console.log(`Ready for Flutter integration testing!\n`);
});
