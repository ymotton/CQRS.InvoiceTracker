using System;

namespace CQRS.InvoiceTracker.CommandHandlers
{
    public abstract class Command
    {
        public Guid Id { get; protected set; }

        protected Command(Guid id)
        {
            Id = id;
        }
    }
}
