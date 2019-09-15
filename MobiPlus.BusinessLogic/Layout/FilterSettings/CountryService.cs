using DAL.LayoutRepository.FilterSettings;
using MobiPlus.Models.Common;
using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.BusinessLogic.Layout.FilterSettings
{
    public class CountryService : IRepository<CountryModel, FilterParams>
    {
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

        protected CountryRepository repository;
        public CountryService()
        {
            this.repository = new CountryRepository();
        }

        public async Task<IEnumerable<CountryModel>> GetAll()
        {
            return await this.repository.GetAll();
        }

        public  Task<CountryModel> GetDataByID(FilterParams param)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<CountryModel>> GetFilteredData(FilterParams param)
        {
            return await this.repository.GetFilteredData(param);
        }
    }
}
