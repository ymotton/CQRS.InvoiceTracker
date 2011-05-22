using System;
using System.Runtime.Serialization;
using CQRS.InvoiceTracker.CommandHandlers;

namespace CQRS.InvoiceTracker.Commands
{
    public class CreateUserCommand : Command
    {
        public CreateUserCommand(string userName, string email, string password)
            : base()
        {
            UserName = userName;
            Email = email;
            Password = password;
        }
        
        public CreateUserCommand(Guid id, string userName, string email, string password)
            : base(id)
        {
            UserName = userName;
            Email = email;
            Password = password;
        }
        
        [DataMember]
        public string UserName { get; private set; }
        
        [DataMember]
        public string Email { get; private set; }
        
        [DataMember]
        public string Password { get; private set; }
    }
}
