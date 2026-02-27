// ============================================
// Supabase Pulse — API Server Entry Point
// ============================================
import express from 'express';
import cors from 'cors';
import { handleAuthExchange } from './server.js';
import { validateConfig, SupabaseManager, DashboardAPI, tokenStore } from './index.js';

// Global instances
const manager = new SupabaseManager();
let dashboard = null;

// Initialise Dashboard if tokens exist for 'default-user'
const saved = tokenStore.getTokens('default-user');
if (saved) {
    const client = manager.getManagementClient(saved.access_token);
    dashboard = new DashboardAPI(client);
}

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
app.post('/api/auth/exchange', async (req, res) => {
    await handleAuthExchange(req, res);

    // After exchange, refresh our global dashboard instance
    const saved = tokenStore.getTokens('default-user');
    if (saved) {
        const client = manager.getManagementClient(saved.access_token);
        dashboard = new DashboardAPI(client);
    }
});

// ── Management API Endpoints ──────────────────

// List Projects
app.get('/api/projects', async (req, res) => {
    if (!dashboard) return res.status(401).json({ error: 'Not authenticated with Supabase' });
    try {
        const projects = await dashboard.projects.listProjects();
        res.json(projects);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// List Organizations
app.get('/api/organizations', async (req, res) => {
    if (!dashboard) return res.status(401).json({ error: 'Not authenticated with Supabase' });
    try {
        const orgs = await dashboard.orgs.listOrganizations();
        res.json(orgs);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

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
