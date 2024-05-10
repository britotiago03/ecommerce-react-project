import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useCart } from '../contexts/CartContext';
import '../css/CategoryProducts.css'; // Ensure CSS is correctly linked

function CategoryProducts() {
    const { categoryName } = useParams();
    const { addToCart } = useCart();
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch(`http://localhost:5000/products/category/${categoryName}`) // Ensure this endpoint exists and is configured to return products by category name
            .then(response => response.json())
            .then(data => {
                setProducts(data);
                setLoading(false);
            })
            .catch(err => {
                console.error('Error fetching products by category:', err);
                setLoading(false);
            });
    }, [categoryName]);

    if (loading) return <div>Loading products...</div>;
    if (!products.length) return <div>No products found in this category.</div>;

    return (
        <div className="category-products">
            <h2>Products in {categoryName}</h2>
            <div className="category-product-list">
                {products.map(product => (
                    <div key={product.ProductID} className="category-product">
                        <img src={product.ImageURL} alt={product.Name} style={{ width: '200px', height: '200px', objectFit: 'contain' }} />
                        <h3>{product.Name}</h3>
                        <p>{product.Description}</p>
                        <p>Price: {product.Price},-</p>
                        <button onClick={() => addToCart({...product, id: product.ProductID})}>Add to Cart</button>
                        <Link to={`/product/${product.ProductID}`}>View Details</Link>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default CategoryProducts;
