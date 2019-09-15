using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL.LayoutRepository.Dashboard;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;

namespace MobiPlus.BusinessLogic.Layout.Dashboard
{
    public class WidgetService : IFilterRepository<WidgetModel, WidgetParams>
    {
        protected WidgetRepository repository;

        public WidgetService()
        {
            this.repository = new WidgetRepository();
        }
        public async Task<IEnumerable<WidgetModel>> GetDataByID(WidgetParams param)
        {
            return await this.repository.GetDataByID(param);
        }

        public async Task<WidgetModel> POD_Widget_SelectAsync(WidgetParams inParams)
        {
            return await this.repository.POD_Widget_SelectAsync(inParams);
        }

        public async Task<WidgetModel> Layout_POD_Widget_NotFullDeliveryAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_Widget_NotFullDeliveryAsync(inParams);
        }

        public async Task<WidgetModel> Layout_POD_Widget_DeliveryAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_Widget_DeliveryAsync(inParams);
        }

        public async Task<WidgetModel> Layout_POD_Widget_AgentReturnAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_Widget_AgentReturnAsync(inParams);
        }
        public async Task<WidgetModel> Layout_POD_Widget_TasksAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_Widget_TasksAsync(inParams);
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


        public async Task<WidgetModel> Layout_POD_Widget_NonVisitAsync(FilterParams inParams)
        {
            return await this.repository.Layout_POD_Widget_NonVisitAsync(inParams);
        }
    }
}
