using CQRS.InvoiceTracker.Domain;

namespace CQRS.InvoiceTracker.CommandHandlers
{
    /// <summary>
    /// Simple facade over our domain, in general do not have behavior.
    /// Should be coordinating the Domain, and pushing behaviours into the domain. The behavior should be part of the Domain object
    /// 
    /// You don't commit transactions, authorization, logging here... not even AOP
    /// </summary>
    /// <typeparam name="TAggregate"></typeparam>
    /// <typeparam name="TCommand"></typeparam>
    public abstract class CommandHandler<TAggregate, TCommand> : IHandler<TCommand>
        where TAggregate : class
        where TCommand : class
    {
        protected Repository<TAggregate> Repository { get; set; }

        protected CommandHandler(Repository<TAggregate> repository)
        {
            Repository = repository;
        }

        public abstract void Handle(TCommand command);
    }
}
