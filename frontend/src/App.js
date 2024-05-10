import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { CartProvider } from './contexts/CartContext';
import Header from './components/Header';
import Footer from './components/Footer';
import Home from './components/Home';
import ProductDetails from './components/ProductDetails';
import CategoryProducts from './components/CategoryProducts';
import Cart from './components/Cart';
import SignIn from './components/SignIn';
import NotFound from './components/NotFound';
import SearchResults from './components/SearchResults';

function App() {
    return (
        <CartProvider>
            <Router>
                <div className="App">
                    <Header />
                    <Routes>
                        <Route path="/" element={<Home />} />
                        <Route path="/search" element={<SearchResults />} />
                        <Route path="/product/:productId" element={<ProductDetails />} />
                        <Route path="/category/:categoryName" element={<CategoryProducts />} />
                        <Route path="/cart" element={<Cart />} />
                        <Route path="/signin" element={<SignIn />} />
                        <Route path="*" element={<NotFound />} />
                    </Routes>
                    <Footer />
                </div>
            </Router>
        </CartProvider>
    );
}

export default App;
