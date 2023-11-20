import { LightningElement, wire } from 'lwc';
import getImages from '@salesforce/apex/PhotoController.getImages';

export default class imagesGallery extends LightningElement {

    isLoading = true;
    searchTerm = '';
    images;
    filteredImages;
    noMatchingRecords = false;
    noRecords = false;

    @wire(getImages)
    wiredImages({ error, data }) {
        if (data) {
            this.images = data.map(image => ({
                                id: image.Id__c,
                                url: image.Url__c,
                                download_url: image.Download_url__c,
                                author: image.Author__c,
                                title: image.Title__c
            }));
             this.filteredImages = this.images;
                     if ( this.images.length === 0) {
                         this.noRecords = true;
                     }
             setTimeout(() => {
                             this.isLoading = false;
                         }, 2000);
        } else if (error) {
            console.error('Error fetching images:', error);
        }
    }

    handleSearch(event) {
        this.searchTerm = event.target.value.toLowerCase();;
        this.filterImages();
    }

    filterImages() {
        this.filteredImages = this.images.filter(image => image.title.toLowerCase().includes(this.searchTerm));
        if ( this.filteredImages.length == 0) {
            this.noMatchingRecords = true;
        }
    }
}