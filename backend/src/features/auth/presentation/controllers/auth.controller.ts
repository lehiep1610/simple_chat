import { LoginUsecase } from "../../domain/usecases/login.usecase";
import { RegisterUsecase } from "../../domain/usecases/register.usecase";
import { Request, Response, NextFunction } from 'express';

export class AuthController {
    constructor(private loginUsecase: LoginUsecase, private registerUsecase: RegisterUsecase) { }

    register = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { email, password, name } = req.body;
            const user = await this.registerUsecase.execute({ email, password, name });
            res.status(201).json({ user });
        } catch (error) {
            next(error);
        }
    };

    login = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { email, password } = req.body;
            const result = await this.loginUsecase.execute({ email, password });
            res.json(result);
        } catch (error) {
            next(error);
        }
    };
}