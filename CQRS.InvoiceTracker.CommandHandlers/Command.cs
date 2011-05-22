using System;
using System.Runtime.Serialization;

namespace CQRS.InvoiceTracker.CommandHandlers
{
    [DataContract]
    public abstract class Command
    {
        [DataMember]
        public Guid Id { get; protected set; }

        protected Command()
        {
            Id = Guid.NewGuid();
        }
        
        protected Command(Guid id)
        {
            Id = id;
        }
    }
}
