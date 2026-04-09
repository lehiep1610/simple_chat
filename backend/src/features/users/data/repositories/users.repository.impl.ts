import { UsersPage } from "../../domain/entities/user-preview.entity";
import { GetUsersParams, UsersRepository } from "../../domain/repositories/users.repository";
import { UsersDatasource } from "../datasources/users.datasource";

export class UsersRepositoryImpl implements UsersRepository {
    constructor(private usersDatasource: UsersDatasource) { }

    async getUsers(params: GetUsersParams): Promise<UsersPage> {
        return this.usersDatasource.getUsers(params);
    }
}
