import './App.css';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import UploadFile from './components/UploadFile';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

function App() {
  return (
    <div className="App">
      <Router>
        <Navbar/>
        <Routes>
          <Route path='/' exact/>
        </Routes>
      </Router>
      <Hero/>
      <UploadFile/>
    </div>
  );
}

export default App;
