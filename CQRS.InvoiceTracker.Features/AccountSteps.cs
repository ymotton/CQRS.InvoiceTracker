using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web.Security;
using TechTalk.SpecFlow;

namespace CQRS.InvoiceTracker.Features
{
    public class AccountSteps : StepBase
    {
        [BeforeScenario]
        public void TestInitialize()
        {
            Membership.DeleteUser("validusername");
        }
    }
}
