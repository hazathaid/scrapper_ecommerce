export default function Navbar() {
  return (
    <nav className="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-4 shadow">
      <div className="max-w-6xl mx-auto flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">Scraper E-Commerce</h1>
        <div>
          <button className="bg-white text-blue-600 px-4 py-2 rounded-lg font-medium hover:bg-gray-100 transition">
            Dashboard
          </button>
        </div>
      </div>
    </nav>
  );
}
