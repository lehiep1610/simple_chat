import { UsersPage } from "../entities/user-preview.entity";
import { GetUsersParams, UsersRepository } from "../repositories/users.repository";

export class GetUsersUsecase {
    constructor(private usersRepository: UsersRepository) { }

    async execute(params: GetUsersParams): Promise<UsersPage> {
        return this.usersRepository.getUsers(params);
    }
}
