using System;
using CQRS.InvoiceTracker.Domain;

namespace CQRS.InvoiceTracker.CommandHandlers
{
    public class CreateUserCommandHandler : CommandHandler<User, CreateUserCommand>
    {
        public CreateUserCommandHandler(Repository<User> repository)
            : base(repository)
        {
        }

        public override void Handle(CreateUserCommand command)
        {
            // TODO : SHOULDN'T BE HERE !!!! Should it ?
            bool existingUserEmail = Repository.Any(u =>
                u.Name.ToLowerInvariant() == command.UserName.ToLowerInvariant()
             || u.Email.ToLowerInvariant() == command.Email.ToLowerInvariant());

            if (existingUserEmail)
            {
                throw new InvalidOperationException("Existing UserName/Email");
            }

            var newUser = new User(command.UserName, command.Email);
        }
    }
}
