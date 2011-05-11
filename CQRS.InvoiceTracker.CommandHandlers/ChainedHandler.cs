namespace CQRS.InvoiceTracker.CommandHandlers
{
    public abstract class ChainedHandler<TCommand> : IHandler<TCommand> 
        where TCommand : class
    {
        protected IHandler<TCommand> NextHandler;
        protected ChainedHandler(IHandler<TCommand> handler)
        {
            NextHandler = handler;
        }

        public abstract void Handle(TCommand command);
    }
}
