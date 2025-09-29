import { useState } from "react";
import axios from "axios";

export default function Home() {
  const [url, setUrl] = useState("");
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(false);

  const scrapeProduct = async () => {
    try {
      setLoading(true);
      const res = await axios.post("http://localhost:3000/scrape", { url });
      setProduct(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex justify-center items-center min-h-[80vh] bg-gray-50 px-4">
      <div className="bg-white shadow-lg rounded-xl p-8 w-full max-w-lg">
        <h2 className="text-2xl font-semibold mb-6 text-gray-800">
          Scrape Product
        </h2>

        {/* Input */}
        <div className="flex gap-2">
          <input
            type="text"
            value={url}
            placeholder="Enter Flipkart product URL"
            onChange={(e) => setUrl(e.target.value)}
            className="flex-1 border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:outline-none"
          />
          <button
            onClick={scrapeProduct}
            disabled={loading}
            className={`px-6 py-2 rounded-lg transition text-white ${
              loading
                ? "bg-blue-400 cursor-not-allowed"
                : "bg-blue-600 hover:bg-blue-700"
            }`}
          >
            {loading ? "Scraping..." : "Scrape"}
          </button>
        </div>

        {/* Result */}
        {product && (
          <div className="mt-8 border-t pt-6">
            <h3 className="text-xl font-semibold text-gray-800 mb-4">Product Result</h3>
            <div className="bg-gray-50 p-4 rounded-lg shadow">
              <h4 className="text-lg font-bold text-gray-900">{product.name}</h4>
              <p className="text-gray-600 mt-1">{product.description}</p>
              <div className="mt-3">
                <span className="text-xl font-semibold text-green-600">
                  {product.price}
                </span>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
