// FeaturedProducts.js
import React from 'react';
import '../css/FeaturedProducts.css'

function FeaturedProducts({ title, products }) {
    return (
        <div className="featured-products">
            <h2>{title}</h2>
            <div className="product-list">
                {products.map(product => (
                    <div key={product.id} className="product">
                        <img src={product.image} alt={product.name} />
                        <h3>{product.name}</h3>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default FeaturedProducts;
