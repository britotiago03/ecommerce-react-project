import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useCart } from '../contexts/CartContext'; // Import useCart
import '../css/Header.css';

function Header() {
    const { cart } = useCart(); // Access the cart context
    const [searchTerm, setSearchTerm] = useState('');
    const [brands, setBrands] = useState([]);
    const [selectedBrand, setSelectedBrand] = useState('All Brands');
    const navigate = useNavigate();

    useEffect(() => {
        fetch('http://localhost:5000/brand')
            .then(response => response.json())
            .then(data => setBrands(data))
            .catch(console.error);
    }, []);

    const handleSearchChange = (e) => {
        setSearchTerm(e.target.value);
    };

    const handleSearchSubmit = (e) => {
        e.preventDefault();
        navigate(`/search?query=${searchTerm}&brand=${selectedBrand}`);
    };

    const handleBrandChange = (e) => {
        setSelectedBrand(e.target.value);
    };

    // Calculate total items in the cart
    const totalItems = cart.items.reduce((total, item) => total + item.quantity, 0);

    return (
        <header>
            <div className="logo">
                <Link to="/">ElectroMart</Link>
            </div>
            <form className="search-bar" onSubmit={handleSearchSubmit}>
                <select value={selectedBrand} onChange={handleBrandChange} className="brand-select">
                    <option value="All Brands">All Brands</option>
                    {brands.map(brand => (
                        <option key={brand.BrandID} value={brand.Name}>{brand.Name}</option>
                    ))}
                </select>
                <input type="text" placeholder="Search ElectroMart" value={searchTerm} onChange={handleSearchChange} />
                <button type="submit"><i className="fa-solid fa-magnifying-glass"></i></button>
            </form>
            <div className="user-controls">
                <Link to="" className="signin-button">
                    <i className="fa-solid fa-user"></i>
                    <span>Sign In</span>
                </Link>
                <Link to="/cart" className="cart-button">
                    <i className="fa-solid fa-cart-shopping"></i>
                    <span>Cart{totalItems > 0 ? ": " + totalItems : ''}</span>
                </Link>
            </div>
        </header>
    );
}

export default Header;
