import express, { Request, Response } from 'express';

const app = express();
const PORT = 3000;

app.use(express.json());

app.get("/", (req: Request, res: Response) => {
    console.log("Recceiving request at root route");
    res.json({ message: "Hello World!!!!!" });
})

app.get("/ping", (req: Request, res: Response) => {
    res.json({ message: "pong" });
})

app.post("/auth/login", (req: Request, res: Response) => {
    const { email, password } = req.body;
    console.log(`Recceiving request at login email : ${email}`);

    res.json({ token: "mock-jwt-token-12345", user: { id: "1", email: email, name: "Test User", avatar_url: null } });
});

app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
})