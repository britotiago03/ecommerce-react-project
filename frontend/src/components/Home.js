// Home.js
import React from 'react';
import Carousel from './Carousel';
import FeaturedProducts from './FeaturedProducts';
import Navigation from './Navigation';
import '../css/Home.css'

// Sample data for Carousel and FeaturedProducts
const sampleBanners = [
    { id: 1, image: '/images/essentials_for_gamers.jpg', title: 'Banner 1' },
    { id: 2, image: '/images/gifts_to_make_mom_smile.jpg', title: 'Banner 2' }
];

const sampleProducts = [
    { id: 1, name: 'Headsets', price: 99.99, image: '/images/featured_products/headsets.png' },
    { id: 2, name: 'Gaming mice', price: 199.99, image: '/images/featured_products/gaming_mice.png' },
    { id: 3, name: 'Laptops', price: 199.99, image: '/images/featured_products/laptops.png' },
    { id: 4, name: 'Keyboards', price: 199.99, image: '/images/featured_products/keyboards.png' },
    { id: 5, name: 'Chairs', price: 199.99, image: '/images/featured_products/chairs.png' }
];

function Home() {
    return (
        <div className="home-page">
            <Navigation />
            <Carousel banners={sampleBanners} />
            <FeaturedProducts title="Gaming Accessories" products={sampleProducts} />
        </div>
    );
}

export default Home;
