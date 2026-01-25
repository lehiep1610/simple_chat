import { User, UserWithPassword } from "../../domain/entities/user.entity";
import { AuthRepository } from "../../domain/repositories/auth.repository";
import { AuthDatasource } from "../datasources/auth.datasource";

export class AuthRepositoryImpl implements AuthRepository {
    constructor(private authDatasource: AuthDatasource) { }

    async findByEmail(email: string): Promise<UserWithPassword | null> {
        return this.authDatasource.findByEmail(email);
    }

    async findById(id: string): Promise<User | null> {
        return this.authDatasource.findById(id);
    }
    async create(user: { email: string, hashedPassword: string, name: string }): Promise<User> {
        return this.authDatasource.create(user);
    }
}