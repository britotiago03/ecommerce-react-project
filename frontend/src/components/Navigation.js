// Navigation.js
import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import '../css/Navigation.css'

function Navigation() {
    const [categories, setCategories] = useState([]);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        try {
            const response = await fetch('http://localhost:5000/categories'); // Adjust this URL to where your API is hosted
            if (!response.ok) throw new Error('Failed to fetch');
            const data = await response.json();
            setCategories(data);
        } catch (error) {
            console.error('Error fetching categories:', error);
            setError(error.message);
        }
    };

    if (error) return <p>Error loading categories: {error}</p>;

    return (
        <nav className="category-nav">
            <ul>
                {categories.map(category => (
                    <li key={category.CategoryID}>
                        <Link to={`/category/${category.Name}`}>{category.Name}</Link>
                    </li>
                ))}
            </ul>
        </nav>
    );
}

export default Navigation;
