import { NavLink } from "react-router-dom";

export default function Navbar() {
  const baseClass =
    "px-4 py-2 rounded-lg font-medium transition";
  const inactiveClass =
    "bg-white text-blue-600 hover:bg-gray-100";
  const activeClass =
    "bg-blue-800 text-white";

  return (
    <nav className="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-4 shadow">
      <div className="max-w-6xl mx-auto flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">Scraper E-Commerce</h1>
        <div className="flex gap-4">
          <NavLink
            to="/"
            className={({ isActive }) =>
              `${baseClass} ${isActive ? activeClass : inactiveClass}`
            }
          >
            Dashboard
          </NavLink>
          <NavLink
            to="/products"
            className={({ isActive }) =>
              `${baseClass} ${isActive ? activeClass : inactiveClass}`
            }
          >
            Products
          </NavLink>
        </div>
      </div>
    </nav>
  );
}
