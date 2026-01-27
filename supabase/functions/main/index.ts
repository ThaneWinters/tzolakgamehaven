// Main router for SELF-HOSTED deployments only
// In Lovable Cloud, each function is deployed independently and this file is just a stub

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// List of available functions for self-hosted routing
const AVAILABLE_FUNCTIONS = [
  "bgg-import",
  "bgg-lookup", 
  "bulk-import",
  "condense-descriptions",
  "decrypt-messages",
  "game-import",
  "image-proxy",
  "manage-users",
  "rate-game",
  "send-email",
  "send-message",
  "wishlist",
];

export default async function handler(req: Request): Promise<Response> {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const url = new URL(req.url);
  const pathParts = url.pathname.split("/").filter(Boolean);
  const functionName = pathParts[0];

  if (!functionName) {
    return new Response(
      JSON.stringify({ error: "Function name required", available: AVAILABLE_FUNCTIONS }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }

  if (!AVAILABLE_FUNCTIONS.includes(functionName)) {
    return new Response(
      JSON.stringify({ error: `Unknown function: ${functionName}`, available: AVAILABLE_FUNCTIONS }),
      { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }

  try {
    // Dynamic import for self-hosted - works in edge-runtime with mounted volume
    const modulePath = `../${functionName}/index.ts`;
    const module = await import(modulePath);
    
    // Call the default export handler
    if (typeof module.default === "function") {
      return await module.default(req);
    }
    
    return new Response(
      JSON.stringify({ error: `Function ${functionName} has no default export` }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error(`Error loading function ${functionName}:`, error);
    return new Response(
      JSON.stringify({ 
        error: `Failed to load function: ${functionName}`,
        details: error instanceof Error ? error.message : String(error)
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
}

// For Lovable Cloud deployment (this becomes a standalone stub)
Deno.serve(handler);
