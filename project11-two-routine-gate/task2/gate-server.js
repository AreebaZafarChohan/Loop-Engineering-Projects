const http = require('http');
const { execSync } = require('child_process');

const TOKEN = process.env.GATE_TOKEN;

const server = http.createServer((req, res) => {
  const auth = req.headers['authorization'];
  if (auth !== `Bearer ${TOKEN}`) {
    res.writeHead(401);
    res.end('Unauthorized');
    return;
  }
  try {
    const output = execSync('git checkout main && git merge claude/release-draft', { encoding: 'utf8', cwd: 'D:\\Gemini_Cli\\Loop-Engineering' });
    res.writeHead(200);
    res.end('Approved and merged:\n' + output);
    console.log('MERGE ACTION EXECUTED:\n', output);
  } catch (err) {
    res.writeHead(500);
    res.end('Merge failed: ' + err.message);
  }
});

server.listen(3939, () => console.log('Gate server listening on port 3939'));