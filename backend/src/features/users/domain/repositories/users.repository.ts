import { UsersPage } from "../entities/user-preview.entity";

export interface GetUsersParams {
    currentUserId: string;
    limit: number;
    offset: number;
}

export interface UsersRepository {
    getUsers(params: GetUsersParams): Promise<UsersPage>;
}
