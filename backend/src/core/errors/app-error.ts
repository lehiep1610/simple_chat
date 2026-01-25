export class AppError extends Error {
    constructor(public message: string, public statusCode: number = 500, public isOperational: boolean = true) {
        super(message);
        // Ensure the error is an instance of AppError
        Object.setPrototypeOf(this, AppError.prototype);
    }
}

export class NotFoundError extends AppError {
    constructor(message: string = `Resource not found`) {
        super(message, 404, true);
    }
}

export class BadRequestError extends AppError {
    constructor(message: string = `Bad request`) {
        super(message, 400, true);
    }
}

export class UnauthorizedError extends AppError {
    constructor(message: string = `Unauthorized`) {
        super(message, 401, true);
    }
}

export class ConflictError extends AppError {
    constructor(message: string = `Resource already exists`) {
        super(message, 409, true);
    }
}
