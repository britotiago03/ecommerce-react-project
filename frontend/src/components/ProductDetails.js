import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { useCart } from '../contexts/CartContext';
import '../css/ProductDetails.css'; // Make sure to import the CSS file

function ProductDetails() {
    const { productId } = useParams();
    const { addToCart } = useCart();
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch(`http://localhost:5000/products/${productId}`)
            .then(response => response.json())
            .then(data => {
                setProduct(data);
                setLoading(false);
            })
            .catch(err => console.error('Error fetching product details:', err));
    }, [productId]);

    if (loading) return <p>Loading...</p>;
    if (!product) return <p>Product not found!</p>;

    return (
        <div className="product-details">
            <h1>{product.Name}</h1>
            <img src={product.ImageURL} alt={product.Name} />
            <div className="product-info">
                <p className="product-price">Price: {product.Price},-</p>
                <p>Description: {product.Description}</p>
                <p>Category: {product.CategoryName}</p>
                <p>Brand: {product.BrandName}</p>
                <p>Stock: {product.StockQuantity} units available</p>
                <p>Dimensions: {product.Dimensions}</p>
                <p>Weight: {product.Weight}kg</p>
                <button onClick={() => addToCart({...product, id: product.ProductID})}>Add to Cart</button>
            </div>
        </div>
    );
}

export default ProductDetails;
