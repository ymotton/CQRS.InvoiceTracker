using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;
using WatiN.Core;

namespace CQRS.InvoiceTracker.Features
{
    [Binding]
    public abstract class StepBase
    {
        protected IE Browser;

        [BeforeScenario]
        public void ScenarioInitialization()
        {
            Browser = new IE();
        }

        [Given(@"I am on the ""(.*)"" page")]
        public void Given_IAmOnThePage(string pageName)
        {
            Browser.GoTo(string.Format("http://localhost:2290{0}", pageName));
        }

        [When(@"I click the ""(.*)"" button")]
        public void When_IPressTheButton(string buttonName)
        {
            Button button = Browser.Button(Find.ByValue(buttonName));
            button.WaitUntilExists(2);
            button.Click();
        }

        [When(@"I click the ""(.*)"" link")]
        public void When_IPressTheLink(string linkName)
        {
            Link link = Browser.Link(Find.ByText(linkName));
            link.WaitUntilExists(2);
            link.Click();
        }

        [When(@"I input ""(.*)"" into the ""(.*)"" field")]
        public void When_IInputIntoTheField(string value, string fieldName)
        {
            TextField textField = Browser.TextField(Find.ByName(fieldName));
            textField.WaitUntilExists(2);
            textField.TypeText(value);
        }

        [Then(@"I should see the ""(.*)"" page show up")]
        public void Then_IShouldSeeTheCreateUserPageShowUp(string pageTitle)
        {
            Assert.IsNotNull(Browser.Title, "The Title is not filled out");
            Assert.IsTrue(Browser.Title.Equals(pageTitle, StringComparison.OrdinalIgnoreCase), "The Title does not match");
        }

        [Then(@"I click the ""(.*)"" link")]
        public void Then_IPressTheLink(string linkName)
        {
            Link link = Browser.Link(Find.ByText(linkName));
            link.WaitUntilExists(2);
            link.Click();
        }
        
        [AfterScenario]
        public void ScenarioCleanup()
        {
            Browser.Dispose();
        }
    }
}
