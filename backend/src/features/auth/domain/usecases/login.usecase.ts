import bcrypt from 'bcrypt';
import jwt, { SignOptions } from 'jsonwebtoken';
import { AuthRepository } from '../repositories/auth.repository';
import { User } from '../entities/user.entity';
import { UnauthorizedError } from '../../../../core/errors/app-error';

export class LoginUsecase {
    constructor(private authRepository: AuthRepository) { }

    async execute(params: { email: string, password: string }): Promise<{ user: User, token: string }> {
        const { email, password } = params;

        //Find user
        const user = await this.authRepository.findByEmail(email);
        if (!user) {
            throw new UnauthorizedError('Invalid email or password');
        }

        //Verify password
        const isValidPassword = await bcrypt.compare(password, user.hashedPassword);
        if (!isValidPassword) {
            throw new UnauthorizedError('Invalid email or password');
        }

        //Generate token
        const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET!, { expiresIn: process.env.JWT_EXPIRES_IN || '1h' } as SignOptions);

        const { hashedPassword, ...userWithoutPassword } = user;
        return { user: userWithoutPassword, token };
    }
}