// ============================================
// Supabase Pulse — ProjectManager
// ============================================
// Logic for managing projects via the 
// Supabase Management API.
// ============================================

export default class ProjectManager {
    constructor(apiClient) {
        this.client = apiClient;
    }

    /**
     * List all projects the user has access to.
     * 
     * @returns {Promise<Array>} List of project objects
     */
    async listProjects() {
        console.log('[ProjectManager] 📊 Fetching all projects...');
        try {
            const projects = await this.client.getProjects();
            return projects;
        } catch (error) {
            throw new Error(`[ProjectManager] Failed to list projects: ${error.message}`);
        }
    }

    /**
     * Get specific project details by project ref.
     * 
     * @param {string} projectRef - Unique identifier for the project
     * @returns {Promise<object>} Project details
     */
    async getProject(projectRef) {
        if (!projectRef) throw new Error('[ProjectManager] projectRef is required.');

        try {
            // In the SDK, you might need to find it in the list or use a specific get call if available
            const projects = await this.listProjects();
            const project = projects.find(p => p.id === projectRef || p.ref === projectRef);

            if (!project) throw new Error(`Project with ref ${projectRef} not found.`);
            return project;
        } catch (error) {
            throw new Error(`[ProjectManager] Failed to get project ${projectRef}: ${error.message}`);
        }
    }

    /**
     * Create a new project (Scaffold).
     * Note: This usually requires a paid plan or empty slots.
     * 
     * @param {object} params
     * @param {string} params.name
     * @param {string} params.organizationId
     * @param {string} params.dbPass
     * @param {string} params.region
     * @returns {Promise<object>} New project details
     */
    async createProject({ name, organizationId, dbPass, region }) {
        console.log(`[ProjectManager] ✨ Creating new project: ${name}...`);
        try {
            const newProject = await this.client.createProject({
                name,
                organization_id: organizationId,
                db_pass: dbPass,
                region,
                plan: 'free' // Default to free plan
            });
            return newProject;
        } catch (error) {
            throw new Error(`[ProjectManager] Failed to create project: ${error.message}`);
        }
    }
}
