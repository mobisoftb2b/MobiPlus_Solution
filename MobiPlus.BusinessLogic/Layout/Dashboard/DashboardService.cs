using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using DAL.LayoutRepository.Dashboard;
using MobiPlus.Models.Common;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.GridDefinition;
using MobiPlus.Models.Tasks;
using MobiPlus.Models.AgentDailyTasks;
using MobiPlus.Models.Hardware;

namespace MobiPlus.BusinessLogic.Layout.Dashboard
{

    public class DashboardService
    {
        protected DashboardRepository repository;

        public DashboardService()
        {
            this.repository = new DashboardRepository();
        }

        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }



        #endregion

        public async Task<List<GridSettings>> Layout_GetReportColsAsync(FilterParams inParams)
        {
            return await this.repository.Layout_GetReportColsAsync(inParams);
        }

        public async Task<List<CustDailyTasks>> Layout_GetReportDataAsync(FilterParams inParams)
        {
            return await this.repository.Layout_GetReportDataAsync(inParams);
        }

        public async Task<List<CustDailyTasks>> Layout_GetNestedDataAsync(FilterParams inParams)
        {
            return await this.repository.Layout_GetNestedDataAsync(inParams);
        }
        public async Task<IEnumerable<DriverStatusModel>> Layout_POD_WEB_DriverStatusAllAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_WEB_DriverStatusAllAsync(inParams);
        }

        public async Task<List<DriverStatusModel>> Layout_DriverStatusPopUpAsync(FilterParams inParams)
        {
            return await this.repository.Layout_DriverStatusPopUpAsync(inParams);
        }

        #region Maps
        public async Task<IEnumerable<DriverModel>> MPLayout_GetDriverGPSLocationByCountryAsync(FilterParams inParams)
        {
            return await this.repository.MPLayout_GetDriverGPSLocationByCountryAsync(inParams);
        }

        public async Task<IEnumerable<Customer>> MPLayout_GetCustomersCordAsync(FilterParams param)
        {
            return await this.repository.MPLayout_GetCustomersCordAsync(param);
        }

        public async Task<IEnumerable<Customer>> Layout_GetCustomersRoadCordAsync(FilterParams param)
        {
            return await this.repository.Layout_GetCustomersRoadCordAsync(param);
        }
        #endregion

        #region End of day
        public async Task<List<EndDayModel>> Layout_POD_WEB_EndDay_SelectAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_WEB_EndDay_SelectAsync(inParams);
        }
        public async Task<List<EndDayModel>> Layout_POD_WEB_EndDayDetails_SelectAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_WEB_EndDayDetails_SelectAsync(inParams);
        }
        #endregion

        #region Notes Collection
        public async Task<IEnumerable<NotesCollectionModel>> Layout_POD_WEB_NotesCollectionAsync(FilterParams param)
        {
            return await this.repository.Layout_POD_WEB_NotesCollectionAsync(param);
        }
        #endregion

        #region Driver Reports
        public async Task<IEnumerable<DriverReports>> Layout_POD_WEB_AgentsReportAsync(FilterParams param)
        {
            return await this.repository.Layout_POD_WEB_AgentsReportAsync(param);
        }

        public async Task<IEnumerable<DriverReportsNT>> Layout_POD_WEB_AgentsReportNoTargetAsync(FilterParams param)
        {
            return await this.repository.Layout_POD_WEB_AgentsReportNoTargetAsync(param);
        }
        #endregion


        #region Customers
        public async Task<IEnumerable<CustomerModel>> Layout_POD_WEB_AgentDailyActivityAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_WEB_AgentDailyActivityAsync(inParams);
        }
        public async Task<IEnumerable<CustomerModel>> Layout_POD_WEB_AgentDailyActivity_PopUpAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_WEB_AgentDailyActivity_PopUpAsync(inParams);
        }

        #endregion
    }
}
