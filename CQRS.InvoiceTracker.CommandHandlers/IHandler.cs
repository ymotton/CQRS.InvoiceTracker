
namespace CQRS.InvoiceTracker.CommandHandlers
{
    public interface IHandler<in TCommand>
        where TCommand : class
    {
        void Handle(TCommand command);
    }
}
