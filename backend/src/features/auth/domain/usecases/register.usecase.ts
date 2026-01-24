import bcrypt from 'bcrypt';
import { AuthRepository } from '../repositories/auth.repository';
import { User } from '../entities/user.entity';
import { ConflictError, BadRequestError } from '../../../../core/errors/app-error';

export class RegisterUsecase {
    constructor(private authRepository: AuthRepository) { }

    async execute(params: { email: string, password: string, name: string }): Promise<User> {
        const { email, password, name } = params;

        //Validate
        if (!email || !password || !name) {
            throw new BadRequestError('Invalid email, password or name');
        }

        //Check if user already exists
        const existingUser = await this.authRepository.findByEmail(email);
        if (existingUser) {
            throw new ConflictError('User already exists');
        }

        //Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const user = await this.authRepository.create({ email, hashedPassword, name });

        return user;
    }
}