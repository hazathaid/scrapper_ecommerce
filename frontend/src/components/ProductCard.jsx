// src/components/ProductCard.jsx
export default function ProductCard({ product }) {
  return (
    <div className="border rounded-lg p-4 shadow hover:shadow-lg transition">
      {product.image_url ? (
        <img
          src={product.image_url}
          alt={product.name}
          className="w-full h-40 object-cover rounded-md mb-4"
        />
      ) : (
        <div className="w-full h-40 bg-gray-100 flex items-center justify-center rounded-md mb-4">
          <span className="text-gray-400">No Image</span>
        </div>
      )}

      <h2 className="text-lg font-semibold mb-2">{product.name}</h2>
      <p className="text-gray-600 mb-2 line-clamp-2">{product.description}</p>
      <p className="text-blue-600 font-bold">
        {new Intl.NumberFormat("id-ID", {
          style: "currency",
          currency: "IDR",
        }).format(product.price)}
      </p>
    </div>
  );
}
