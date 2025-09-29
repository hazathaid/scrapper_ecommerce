// src/components/ProductList.jsx
import ProductCard from "./ProductCard";

export default function ProductList({ products }) {
  if (!products.length) {
    return <p className="text-gray-500">No products found.</p>;
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {products.map((product) => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
