using System;
using System.Data;
using System.Linq;
using System.Data.Entity;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace CQRS.InvoiceTracker.Domain
{
    public class Repository<TAggregate> where TAggregate : class
    {
        protected DbContext Context { get; set; }

        protected Repository()
        {
            Context = new DbContext("name=DomainModel");
        }

        public TAggregate GetById(Guid id)
        {
            return (TAggregate)Context.Set(typeof(TAggregate)).Find(id);
        }

        public IEnumerable<TAggregate> GetFiltered(Expression<Func<TAggregate, bool>> predicate)
        {
            return Context.Set(typeof (TAggregate)).OfType<TAggregate>().Where(predicate).ToList();
        }

        public bool Add(TAggregate aggregate) 
        {
            Context.Set(typeof (TAggregate)).Attach(aggregate);
            Context.Entry(aggregate).State = EntityState.Added;

            return true;
        }
    }
}
