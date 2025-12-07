Fully analyze the entire chess game project and regenerate a complete GEMINI.md documentation file based on the project’s structure, features, architecture, and source code. Follow these steps carefully and produce a polished, comprehensive Markdown document:

1) Project Exploration:
   - Start from the project root and read: pubspec.yaml, README.md, LICENSE, .gitignore.
   - Generate a full recursive directory tree and highlight important directories (lib, src, test, assets).

2) Technology & Dependencies:
   - Detect the main language/framework (Dart/Flutter or others).
   - Extract all dependencies from pubspec.yaml and briefly describe the purpose of key packages.

3) Architecture Analysis:
   - Classify files into layers: domain, data, presentation/UI, services, controllers, utils, models.
   - Detect the state management pattern (GetX, Provider, Bloc, Riverpod, MVC…).
   - Produce a simple architecture diagram (Mermaid or ASCII) showing components and relationships.

4) Code Reading & Feature Extraction:
   - Scan all source files and identify:
     • Entry points (main).
     • Game engine logic (move handling, game rules, validation, board state, etc.).
     • UI controllers/widgets.
     • Storage layers (local storage, database, APIs).
     • Test files.
   - Create a feature list with file:line references for each major feature.

5) Code Quality Assessment:
   - Detect TODOs, FIXMEs, NOTE comments, duplicated code, suspicious patterns.
   - Identify large/complex classes or functions.
   - Check presence of tests, linters, or CI configuration.

6) Risks & Improvements:
   - Provide actionable improvement suggestions (architecture, performance, UI/UX, safety).
   - Highlight potential issues (error handling, race conditions, missing validations).

7) Run & Test Instructions:
   - Document all commands required to install dependencies, run the project, build it, and test it.
   - Mention environment requirements if needed (SDK versions, platform setup).

8) Required GEMINI.md Output:
   - Project title + executive summary.
   - Technologies & dependencies.
   - Directory structure.
   - Architecture diagram.
   - Detailed explanation of major classes/components.
   - Feature list with file references.
   - Known issues and improvement suggestions.
   - TODO list categorized by priority.
   - Run/test instructions.
   - Optional: internal reference links to files.
   - End with a short section summarizing which files were scanned and approximate line counts.

9) Formatting Rules:
   - Use clear Markdown structure with H1/H2/H3 headings.
   - Include tables/lists where helpful.
   - Include short code snippets only when needed.
   - Use relative links to files in the repository.

10) Execution:
   - After completing the full analysis, generate the final `GEMINI.md` in the project root.
   - The file must be complete, polished, and ready for use as official project documentation.

Now execute all steps above on the current project and produce “GEMINI.md”.
