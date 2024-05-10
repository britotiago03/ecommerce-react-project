import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useCart } from '../contexts/CartContext';
import '../css/SearchResults.css'; // Assuming the CSS file is in the same directory

function useQuery() {
    return new URLSearchParams(useLocation().search);
}

function SearchResults() {
    const query = useQuery();
    const searchTerm = query.get('query');
    const selectedBrand = query.get('brand');
    const { addToCart } = useCart();
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!searchTerm) {
            setLoading(false);
            return;
        }

        setLoading(true);
        fetch(`http://localhost:5000/products/search?query=${searchTerm}&brand=${selectedBrand}`)
            .then(response => response.json())
            .then(data => {
                setProducts(data);
                setLoading(false);
            })
            .catch(err => {
                console.error('Error fetching search results:', err);
                setLoading(false);
            });
    }, [searchTerm, selectedBrand]); // Ensure that selectedBrand is part of the dependency array

    if (loading) return <div>Loading...</div>;
    if (!products.length) return <div>No products found.</div>;

    return (
        <div className="search-results">
            <h2>Search Results for "{searchTerm}" under "{selectedBrand}"</h2>
            <div className="search-results-list">
                {products.map(product => (
                    <div key={product.ProductID} className="search-result-item">
                        <img src={product.ImageURL} alt={product.Name}
                             style={{width: '200px', height: '200px', objectFit: 'contain'}}/>
                        <h3>{product.Name}</h3>
                        <p>{product.Description}</p>
                        <p>Price: ${product.Price}</p>
                        <button onClick={() => addToCart({...product, id: product.ProductID})}>Add to Cart</button>
                        <Link to={`/product/${product.ProductID}`}>View Details</Link>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default SearchResults;
