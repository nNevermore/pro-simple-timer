import { execSync } from "node:child_process";
import fs from "node:fs";

console.log("Bumping version...");

try {
  // Run npm version patch
  const output = execSync("npm version patch --no-git-tag-version", {
    encoding: "utf-8",
  }).trim();
  const cleanVersion = output.replace("v", "");
  console.log(`New version: ${cleanVersion}`);

  // Update tauri.conf.json
  const configPath = "src-tauri/tauri.conf.json";
  const config = JSON.parse(fs.readFileSync(configPath, "utf-8"));
  config.version = cleanVersion;
  fs.writeFileSync(configPath, `${JSON.stringify(config, null, 2)}\n`);

  console.log(`Version bumped to ${cleanVersion}`);
} catch (error) {
  console.error("Failed to bump version:", error);
  process.exit(1);
}
