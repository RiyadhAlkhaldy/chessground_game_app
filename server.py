# Filename: server.py
# This script runs a simple MCP server using the mcp-server library.

import random
# تأكد من أن هذا الاستيراد يعمل بعد تثبيت مكتبة mcp-server
try:
    from mcp_server import McpServer, McpHandler
except ImportError:
    print("Error importing mcp_server. Did you run 'pip install mcp-server'?")
    exit(1)

class DiceRollHandler(McpHandler):
    """
    Handler for the Dice Roller server using the MCP protocol.
    """
    async def handle_mcp_message(self, message: dict, context: dict):
        """
        Processes incoming MCP messages asynchronously.
        """
        print(f"Received message: {message}")

        command = message.get("command")
        if command == "roll_dice":
            sides = message.get("sides", 6)
            num_dice = message.get("num_dice", 1)
            
            if not isinstance(sides, int) or not isinstance(num_dice, int) or sides < 1 or num_dice < 1:
                # Returns an error response if input is invalid
                return {"status": "error", "error": "Invalid sides or number of dice."}

            results = [random.randint(1, sides) for _ in range(num_dice)]
            total = sum(results)
            
            # Returns a success response
            return {
                "status": "success",
                "results": results,
                "total": total,
                "message": f"Rolled {num_dice}d{sides}. Total: {total}"
            }
        
        # Default response for unknown commands
        return {"status": "error", "error": "Unknown command", "received_command": command}

if __name__ == "__main__":
    # Initialize the server with the custom handler
    # The server will listen on localhost, default port 8000
    server = McpServer(handler=DiceRollHandler())
    
    print("="*40)
    print("FastMCP Dice Roller Server Starting...")
    print("Listening on 127.0.0.1:8000 (default)")
    print("Use Ctrl+C to stop the server.")
    print("="*40)

    try:
        # This function starts the asynchronous server loop
        server.run()
    except KeyboardInterrupt:
        print("\nServer stopped by user (KeyboardInterrupt).")
    except Exception as e:
        print(f"\nAn unexpected error occurred: {e}")

