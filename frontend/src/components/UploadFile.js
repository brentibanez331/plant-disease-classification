import React, { useState, useRef, useEffect} from 'react'
import './UploadFile.css'
import axios from 'axios'
import { ReactComponent as Loader } from '../assets/loader.svg'

function UploadFile() {
    const [selectedFile, setSelectedFile] = useState()
    const [data, setData] = useState()
    const [preview, setPreview] = useState()
    const [image, setImage] = useState(false)
    const [isLoading, setIsLoading] = useState(false)
    const inputRef = useRef();

    const handleDragOver = (event) => {
        event.preventDefault();
    };

    const handleDrop = (event) => {
        event.preventDefault()
        const droppedFile = event.dataTransfer.files

        setSelectedFile(droppedFile[0]);
        setData(undefined);
        setImage(true);
    }

    let confidence = 0;

    const makePostRequest = async () => {
        try {
            if (image) {
                const endpointUrl = 'https://us-central1-future-graph-411205.cloudfunctions.net/predict';
                let formData = new FormData();
                formData.append("file", selectedFile)

                const response = await axios.post(endpointUrl, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                    },
                });

                if (response.status === 200) {
                    setData(response.data);
                    setIsLoading(false);
                } else {    
                    alert('Request failed with status: ' + response.status);
                }
            }
        } catch (error) {
            alert(error.message);
        }
    }



    const clearData = () => {
        setData(null);
        setImage(false);
        setSelectedFile(null);
        setPreview(null);
        setIsLoading(false);
    }

    useEffect(() => {
        if (!selectedFile) {
            setPreview(undefined);
            return;
        }
        const objectURL = URL.createObjectURL(selectedFile);
        setPreview(objectURL);
    }, [selectedFile]);

    useEffect(() => {
        if (!preview) {
            return;
        }
        setIsLoading(true);
        makePostRequest();
    }, [preview]);

    const onSelectFile = (files) => {
        if (!files || files.length === 0) {
            setSelectedFile(undefined);
            setImage(false);
            setData(undefined);
            return;
        }
        setSelectedFile(files[0]);
        setData(undefined);
        setImage(true);
    }

    if (data) {
        confidence = (parseFloat(data.confidence) * 100).toFixed(2);
    }

    return (
        <div className='upload-section'>
            {preview && (
                <div className="prediction">
                    {preview && (
                        <div className='uploads'>
                            <img src={preview} alt='Uploaded' />
                        </div>

                    )}
                    {isLoading && (
                        <div className='processing'>
                            <Loader className='spinner' />
                            <p>Processing</p>
                        </div>
                    )}

                    {data && (
                        <div className='result-container'>
                            <div className='label'>
                                <p>Label:</p>
                                <h3>{data.plant} {data.status}</h3>
                            </div>
                            <div className='conf'>
                                <p>Confidence:</p>
                                <h4>{data.confidence}%</h4>
                            </div>
                        </div>
                    )}
                </div>
            )}

            {isLoading && (
                <button className='clear-data-btn' onClick={clearData}><h3>CANCEL</h3></button>
            )}

            {data && (
                <button className='clear-data-btn' onClick={clearData}><h3>CLEAR</h3></button>
            )}

            {!preview && (
                <div>
                    <input type='file' onChange={(e) => onSelectFile(e.target.files)} hidden ref={inputRef} />
                    <button onClick={() => inputRef.current.click()}>
                        <div className='file-upload' onDragOver={handleDragOver} onDrop={handleDrop}>
                            <i className='fa-solid fa-arrow-up-from-bracket'></i>
                            <h1 className='drag-and-drop'>Drag and Drop an Image of a Corn Plant Leaf</h1>
                            <p>Or</p>
                            <h1 className='choose-file'>Choose File</h1>
                        </div>
                    </button>
                </div>
            )}


        </div>
    )
}

export default UploadFile