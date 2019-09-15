using Microsoft.VisualStudio.TestTools.UnitTesting;
using MobiPlus.Layout.WebAPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.GridDefinition;

namespace MobiPlus.Layout.WebAPI.Tests
{
    [TestClass()]
    public class DashboardControllerTests
    {
        [TestMethod()]
        public void POD_Widget_SelectAsyncTest()
        {
            var controller = new DashboardController();
            var response = controller.POD_Widget_SelectAsync(new WidgetParams()).GetAwaiter().GetResult();
            Assert.IsNotNull(response);
            Assert.IsInstanceOfType(response, typeof(List<WidgetModel>));
        }

        [TestMethod()]
        public void Layout_GetReportColsAsyncTest()
        {
            var controller = new DashboardController();
            var filter = new FilterParams
            {
                AgentID = 0,
                CountryID = 1000,
                DistrID = 1000,
                FromDate = "20170302",
                ReportID = 257,
                VersionID = 0
            };
            var response = controller.Layout_GetReportColsAsync(filter).GetAwaiter().GetResult();
            
            Assert.IsNotNull(response);
            Assert.IsInstanceOfType(response, typeof(List<GridSettings>));
            Assert.IsTrue(response.Count > 0);
        }

    }
}