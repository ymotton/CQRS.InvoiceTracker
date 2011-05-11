using System.Transactions;

namespace CQRS.InvoiceTracker.CommandHandlers
{
    public class TransactionHandler<TCommand> : ChainedHandler<TCommand> 
        where TCommand : class
    {
        public TransactionHandler(IHandler<TCommand> nextHandler) : base(nextHandler) { }

        public override void Handle(TCommand command)
        {
            using (var scope = new TransactionScope())
            {
                NextHandler.Handle(command);

                scope.Complete();
            }
        }
    }
}
