using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using MobiPlus.BusinessLogic.Layout.Dashboard;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Attributes;
using MobiPlus.Models.GridDefinition;
using MobiPlus.BusinessLogic.Layout.FilterSettings;
using MobiPlus.Models.Common;
using MobiPlus.Models.Tasks;
using MobiPlus.BusinessLogic.Tasks;
using MobiPlus.Models.AgentDailyTasks;
using MobiPlus.Models.Hardware;

namespace MobiPlus.Layout.WebAPI
{
    [RESTAuthorize]
    public class DashboardController : ApiController
    {
        #region Widget area
        [HttpPost]
        public async Task<WidgetModel> POD_Widget_SelectAsync([FromBody]WidgetParams inParams)
        {
            if (inParams == null) inParams = new WidgetParams();
            return await new WidgetService().POD_Widget_SelectAsync(inParams);
        }

        [HttpPost]
        public async Task<WidgetModel> Layout_POD_Widget_NotFullDeliveryAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new WidgetService().Layout_POD_Widget_NotFullDeliveryAsync(inParams);
        }

        [HttpPost]
        public async Task<WidgetModel> Layout_POD_Widget_DeliveryAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new WidgetService().Layout_POD_Widget_DeliveryAsync(inParams);
        }

        [HttpPost]
        public async Task<WidgetModel> Layout_POD_Widget_AgentReturnAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new WidgetService().Layout_POD_Widget_AgentReturnAsync(inParams);
        }

        [HttpPost]
        public async Task<WidgetModel> Layout_POD_Widget_TasksAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new WidgetService().Layout_POD_Widget_TasksAsync(inParams);
        }

        [HttpPost]
        public async Task<WidgetModel> Layout_POD_Widget_NonVisitAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new WidgetService().Layout_POD_Widget_NonVisitAsync(inParams);
        }
        #endregion

        [HttpPost]
        public async Task<List<GridSettings>> Layout_GetReportColsAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DashboardService().Layout_GetReportColsAsync(inParams);
        }
        [HttpPost]
        public async Task<List<CustDailyTasks>> Layout_GetReportDataAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DashboardService().Layout_GetReportDataAsync(inParams);
        }
        [HttpPost]
        public async Task<List<CustDailyTasks>> Layout_GetNestedDataAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DashboardService().Layout_GetNestedDataAsync(inParams);
        }
        [HttpPost]
        public async Task<IEnumerable<CountryModel>> Layout_GetCountryDataAsync([FromBody]FilterParams inParams)
        {
            return await new CountryService().GetFilteredData(inParams);
        }
        [HttpPost]
        public async Task<IEnumerable<DistributionModel>> Layout_GetDistributionDataAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DistributionService().GetDataByID(inParams);
        }
        [HttpPost]
        public async Task<IEnumerable<DriverModel>> Layout_GetDriverDataAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DriverServicecs().GetDataByID(inParams);
        }

        [HttpPost]
        public async Task<IEnumerable<DriverStatusModel>> Layout_POD_WEB_DriverStatusAllAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DashboardService().Layout_POD_WEB_DriverStatusAllAsync(inParams);
        }

        [HttpPost]
        public async Task<IEnumerable<DriverStatusModel>> Layout_DriverStatusPopUpAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DashboardService().Layout_DriverStatusPopUpAsync(inParams);
        }
        [HttpPost]
        public async Task<IEnumerable<TaskModel>> Layout_Tasks_GetAllTasksAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new TaskService().Layout_Tasks_GetAllTasksAsync(inParams);
        }
        [HttpPost]
        public async Task<IEnumerable<DriverModel>> GetAgentsLAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new DriverServicecs().GetAgentsLAsync(inParams);
        }
        [HttpPost]
        public async Task<IEnumerable<TaskModel>> Layout_GetTaskTypesAsync([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new TaskService().Layout_GetTaskTypesAsync(inParams);
        }

        [HttpPost]
        public async Task<IEnumerable<TaskModel>> Layout_SaveTaskAsync([FromBody]TaskModel param)
        {
            if (param == null) param = new TaskModel();
            return await new TaskService().Layout_SaveTaskAsync(param);
        }

        [HttpPost]
        public async Task Layout_DeleteTaskAsync([FromBody]List<int> param)
        {

            await new TaskService().Layout_DeleteTaskAsync(param);
        }

        #region Maps Data
        [HttpPost]
        public async Task<IEnumerable<DriverModel>> Layout_GetDriverGPSLocationByCountryAsync([FromBody]FilterParams param)
        {
            return await new DashboardService().MPLayout_GetDriverGPSLocationByCountryAsync(param);
        }
        [HttpPost]
        public async Task<IEnumerable<Customer>> Layout_GetCustomersCordAsync([FromBody]FilterParams param)
        {
            return await new DashboardService().MPLayout_GetCustomersCordAsync(param);
        }
        [HttpPost]
        public async Task<IEnumerable<Customer>> Layout_GetCustomersRoadCordAsync([FromBody]FilterParams param)
        {
            return await new DashboardService().Layout_GetCustomersRoadCordAsync(param);
        }
        #endregion

        #region EndOfDay
        [HttpPost]
        public async Task<IEnumerable<EndDayModel>> Layout_EndDay_SelectAsync([FromBody]FilterParams param)
        {
            return await new DashboardService().Layout_POD_WEB_EndDay_SelectAsync(param);
        }
        [HttpPost]
        public async Task<IEnumerable<EndDayModel>> Layout_POD_WEB_EndDayDetails_SelectAsync([FromBody]FilterParams param)
        {
            return await new DashboardService().Layout_POD_WEB_EndDayDetails_SelectAsync(param);
        }
        #endregion

    }
}