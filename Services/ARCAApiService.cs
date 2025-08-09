namespace comara.Services
{
    public class ARCAApiService : IARCAApiService
    {
        public async Task<string> GetProductInfo(string productCode)
        {
            // Simulate API call
            await Task.Delay(100);
            return $"Product info for {productCode} from ARCA API (simulated)";
        }

        public async Task<bool> SendSale(object saleData)
        {
            // Simulate API call
            await Task.Delay(100);
            Console.WriteLine($"Sending sale data to ARCA API (simulated): {saleData}");
            return true;
        }
    }
}
